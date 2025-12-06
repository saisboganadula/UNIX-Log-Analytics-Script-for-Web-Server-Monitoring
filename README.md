# UNIX-Log-Analytics-Script-for-Web-Server-Monitoring

log_sum.sh — UNIX Log Analytics Toolkit

A lightweight CLI tool for extracting operational insights from Apache-style web server logs. The script parses thttpd-formatted access logs, surfaces traffic patterns, highlights anomalies, and supports a pipeline-friendly workflow used in day-to-day systems operations.

Features
	•	Identify the IPs making the most connection attempts
	•	Identify the IPs with the most successful requests
	•	List the most common HTTP status codes and their originating IPs
	•	Highlight failure-related status codes (404, 403, etc.) with their sources
	•	Calculate which clients received the most bytes
	•	Optional DNS lookup and blacklist checking (-e flag)
	•	Fully sorted output with optional result limiting

⸻

Usage

log_sum.sh [-L N] (-c|-2|-r|-F|-t) <filename>

Flags
	•	-L N — Limit results to N entries
	•	-c — Top IPs by connection attempts
	•	-2 — Top IPs by successful connections
	•	-r — Status codes sorted by frequency, grouped by IP
	•	-F — Failure-oriented status codes sorted by frequency
	•	-t — Top IPs by bytes transferred
	•	-e — Enable DNS lookup + blacklist detection
	•	<filename> — Log file, or use - / omit to read from stdin

⸻

Examples

Top 10 IPs by connection attempts:
./log_sum.sh -L 10 -c thttpd.log

most common status codes and the IPs generating them:
./log_sum.sh -L 3 -r thttpd.log

Top consumers of outbound bytes:
./log_sum.sh -L 3 -t thttpd.log

Enable blacklist detection:
./log_sum.sh -c -e thttpd.log

How to Run
chmod +x log_sum.sh

./log_sum.sh -c thttpd.log
Works seamlessly in pipelines:
cat thttpd.log | ./log_sum.sh -F -

Implementation Notes
	•	Handles messy, non-delimited log formats
	•	Uses classic UNIX tools for aggregation (sort, uniq, awk)
	•	Caches DNS lookups for efficiency
	•	Output formatting is consistent across all modes
	•	Designed to be transparent, portable, and easy to extend

⸻

Project Context

Built as a student project focused on learning practical log analysis, anomaly detection, and efficient data processing using shell scripting. The emphasis is on operational usefulness rather than academic abstraction.

⸻

Author

Built by Sai Sukheshwar Boganadula (Blekinge Institute of Technology).
