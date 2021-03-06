#pragma once

#include <fdk-aac/aacenc_lib.h>
#include <membrane/membrane.h>
#define MEMBRANE_LOG_TAG "Membrane.AAC.FDK.EncoderNative"
#include <membrane/log.h>

typedef struct _EncoderState {
  HANDLE_AACENCODER handle;
  unsigned char *aac_buffer;
  int channels;
} State;

#include "_generated/encoder.h"
