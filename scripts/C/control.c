#include <stdio.h>
#include <math.h>
#include <time.h>

#define NUM_SAMPLES 10
#define TOTAL_STEPS 500   // 500 * 10ms = 5 seconds
#define DT 0.01f     // 10 ms sampling
#define KV 2.0f      // velocity gain
#define KW 1.5f      // angular gain

// Macros for initial x and y positions
#define x1 -2.0
#define y1 2.0
#define x2 2.0
#define y2 2.0
#define x3 -2.0
#define y3 -2.0
#define x4 2.0
#define y4 2.0

// Simulated load cell data: [F1, F2, F3, F4]
float sample_data[NUM_SAMPLES][4] = {
    {50, 50, 50, 50},
    {55, 60, 50, 45},
    {60, 70, 45, 40},
    {65, 80, 40, 35},
    {70, 90, 35, 30}, // strong forward-right lean
    {72, 95, 33, 28},
    {75, 100, 30, 25},
    {78, 105, 28, 22},
    {80, 110, 25, 20},
    {82, 115, 23, 18}
};

float initial_cop_x = 0.0;
float initial_cop_y = 0.0;

int main() {

    float prev_theta = 0.0f;

    float sum = sample_data[0][0] + sample_data[0][1] + sample_data[0][2] + sample_data[0][3];
    initial_cop_x = (sample_data[0][0] * x1 + sample_data[0][1] * x2 + sample_data[0][2] * x3 + sample_data[0][3] * x4) / sum;
    initial_cop_y = (sample_data[0][0] * y1 + sample_data[0][1] * y2 + sample_data[0][2] * y3 + sample_data[0][3] * y4) / sum;

    // printf("Step |   x      y      r      theta    v      omega\n");
    // printf("------------------------------------------------------\n");

    for (int i = 0; i < TOTAL_STEPS; i++) {

        int idx = i % NUM_SAMPLES;

        // Directly use raw data (no filtering)
        float F1 = sample_data[idx][0];
        float F2 = sample_data[idx][1];
        float F3 = sample_data[idx][2];
        float F4 = sample_data[idx][3];

        float sumF = F1 + F2 + F3 + F4 + 1e-6;

        // Center of Pressure
        float x = (F1 * x1 + F2 * x2 + F3 * x3 + F4 * x4) / sumF;
        float y = (F1 * y1 + F2 * y2 + F3 * y3 + F4 * y4) / sumF;

        // Polar conversion
        float r = sqrtf((x - initial_cop_x) * (x - initial_cop_x) +
                        (y - initial_cop_y) * (y - initial_cop_y));
        float theta = atan2f(y - initial_cop_y, x - initial_cop_x);

        // Control outputs
        float v = KV * r;
        float omega = KW * (theta - prev_theta) / DT;

        prev_theta = theta;

        // printf("%4d | %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f\n",
        //        i, x, y, r, theta, v, omega);

        printf("0.0 %.4f %.4f\n", v, omega);

        // enforce the time step
        struct timespec ts = {0, 10000000L};  // 0 seconds, 10ms in nanoseconds
        nanosleep(&ts, NULL);
    }

    return 0;
}