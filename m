From: David Chow <davidchow@shaolinmicro.com>
Subject: report on RAID tools bug/patch
Date: Fri, 06 Jun 2003 14:44:17 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE03841.1030306@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Referring to the earlier patches you post to fix a problem in mkraid.c 
which saids "array is active -- run raidstop first" . I've try it on 
1.003 from the redhat website and tested it on my system which seems 
alright.  I think this problem has existed in almost all Linux 
distribution as it has been hanging around for a long time. Would you 
please fix it and it will make a lot of people happy :D Thanks.

--- mkraid.c 2002/11/05 19:34:57 1.1
+++ mkraid.c 2002/11/05 19:35:29
@@ -244,7 +244,7 @@ int main (int argc, char *argv[])
     while (*args) {
         for (p = cfg_head; p; p = p->next) {
             if (strcmp(p->md_name, *args)) continue;
- if (check_active(cfg))
+ if (check_active(p))
                 goto abort;
             if (force_flag) {
                 fprintf(stderr, "DESTROYING the contents of %s in 5 
seconds, Ctrl-C if unsure!\n", *args);

regards,
David Chow


