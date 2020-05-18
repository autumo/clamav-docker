FROM alpine:3.11.6

RUN apk add clamav clamav-daemon clamav-libs clamav-libunrar curl sudo linux-headers inotify-tools

RUN mkdir -p /run/clamav && chown clamav:clamav /run/clamav

RUN echo "OnAccessIncludePath /tmp/upload" >> /etc/clamav/clamd.conf && \
  echo "OnAccessPrevention no" >> /etc/clamav/clamd.conf && \
  echo "OnAccessExcludeUname clamav" >> /etc/clamav/clamd.conf && \
  echo "OnAccessExtraScanning yes" >> /etc/clamav/clamd.conf && \
  echo "OnAccessDisableDDD no" >> /etc/clamav/clamd.conf && \
  echo "VirusEvent /usr/sbin/clamav-event.sh \"%v\"" >> /etc/clamav/clamd.conf

RUN echo "Set disable_coredump false" >> /etc/sudo.conf

COPY ./clamav-event.sh /usr/sbin/clamav-event.sh
RUN chmod 755 /usr/sbin/clamav-event.sh

RUN freshclam

CMD sudo clamd && sudo clamonacc --foreground
