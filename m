From: Suresh Grandhi <Sureshg@ami.com>
Subject: Bug in the raidtools-1.00.3 package
Date: Wed, 17 Sep 2003 16:35:49 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8CCBDD5583C50E4196F012E79439B45C058C1F@atl-ms1.megatrends.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
With the raidtools package, mkraid fails while creating devices /dev/md1
when the raid device /dev/md10 is already running.
The problem is that the code has used strstr("/dev/md1", "/dev/md10")  which
returns valid pointer, which outputs 
"array is active - run raidstop first" error message.

I am including a patch for the code.

diff -urN raidtools-1.00.3/raid_io.c raidtools-1.00.3-new/raid_io.c
--- raidtools-1.00.3/raid_io.c  2002-12-11 12:35:14.000000000 -0500
+++ raidtools-1.00.3-new/raid_io.c      2003-09-17 16:20:19.000000000 -0400
@@ -520,6 +520,9 @@
        char buffer[MAX_LINE_LENGTH], line[MAX_LINE_LENGTH], *ch;
        FILE *fp;

+       memset(buffer, 0, MAX_LINE_LENGTH);
+       memset(line, 0, MAX_LINE_LENGTH);
+
        if ((ch = strstr(p->md_name, "/md")) == NULL)
                return 0;
        strcpy(buffer, ch+1);
@@ -528,7 +531,7 @@
        while (1) {
                if ((fgets(line, MAX_LINE_LENGTH, fp)) == NULL)
                        break;
-               if (strstr(line, buffer) && !strstr(line, "inactive")) {
+               if (!strcmp(line, buffer) && !strstr(line, "inactive")) {
                        fprintf(stderr, "%s: array is active -- run raidstop
first.\n", p->md_name);
                        fclose(fp);
                        return 1;

Regards,
Suresh Grandhi
