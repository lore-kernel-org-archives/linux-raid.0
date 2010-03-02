From: Csaba Biegl <bieglc@bellsouth.net>
Subject: Here it is again, this time all text.
Date: Tue, 02 Mar 2010 14:04:26 -0600
Message-ID: <4B8D6F4A.3040105@bellsouth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A message (from<bieglc@bellsouth.net>) was received at 2 Mar 2010 19:41:13 +0000.

The following addresses had delivery problems:

<linux-raid@vger.kernel.org>
	Permanent Failure: MAIL FROM:<bieglc@bellsouth.net>  550 REPLY: 550_5.7.1_Content-Policy_reject_msg:_The_message_contains_HTML_subpart,_therefore_we_consider_it_SPAM_or_Outlook_Virus.__TEXT/PLAIN_is_accepted.!_BF:<U_0.499988>;_S1751601Ab0CBTqi
	Delivery last attempted at Tue,  2 Mar 2010 19:46:38 -0000


Reporting-MTA: dns; isp.att.net
Arrival-Date: 2 Mar 2010 19:41:13 +0000

Final-Recipient: rfc822;<linux-raid@vger.kernel.org>
Action: failed
Status: 5.1.0
Diagnostic-Code: smtp; (Permanent Failure: Other address status)
Last-Attempt-Date: Tue,  2 Mar 2010 19:46:38 -0000


Part 1.2

Subject:
mdadm 3.1.1 feedback
From:
Csaba Biegl <bieglc@bellsouth.net>
Date:
Tue, 02 Mar 2010 13:41:15 -0600

To:
linux-raid@vger.kernel.org
CC:
neilb@suse.de


Neil (and possibly others),

Thanks for your recent work on the new in-kernel and mdadm features that 
allow the use of non-native RAID metadata formats with Linux software 
RAID. I recently put it to the test on two different machines. Below are 
my experiences. Hopefully you will find them useful.

Machines:

#1: HP XW8400 with 6 port Intel SATA controller, supports IMSM. 5x250GB 
SATA drives, set up in BIOS as RAID5, with single virtual array.

#2: Supermicro server with X7DCA-3 motherboard. SATA array connnected to 
integrated LSI 1068E SAS controller. MB has LSI software RAID feature 
enabled (DDF). 8x500GB SATA drives, set up in BIOS as RAID5, with 
multiple virtual arrays.

Both machines dual boot WinXP Pro 64 and 64 bit Linux, the latter being 
the Slackware 13.0 distro.

Observations:

1) On machine #1 mdadm release versions 3.0.3 and 3.1.1 both fail to 
start mdmon, therefore assembled RAID is read only. Checked out latest 
git version of mdadm, runs array fine. After this I did not even bother 
with release versions of mdadm on machine #2.

2) On machine #2 mdadm assembles the DDF BIOS created array fine, 
however upon shutdown it somehow updates the metadata in a way that the 
BIOS does not recognize the arrays any more. But booting Linux again -- 
of course not from the freshly trashed RAID :-( -- the array can be 
re-assembled using mdadm.

3) The latest git version of mdmon has some command line processing bugs 
that will crash the program if no container is given on the command line 
(i.e. "mdmon --all --takeover", etc..). Patch attached.

4) The static linked version of mdmon crashes in the forked daemon 
process. According to "gdb mdmon core", the crash is in one of the 
signal handlers ("wake_me") which gets called with an invalid stack 
pointer. To me it looks like this is not mdmon's problem but rather a 
brain-dead static libc. Did not try other environments, so I do not know 
whether this is Slackware and/or 64 bit specific.

Question:

I chose a startup/initrd approach somewhat different than what is 
suggested in the documentation. It is based on the fact that the RAID 
array can be assembled in read-only mode just by "mdadm" without an 
available "mdmon". Relevant steps from the initrd's init script:

   mdadm -Es > /etc/mdadm.conf
   mdadm -As
   mount -r /dev/mdXpY /mnt
   mount -n -t tmpfs initrw /mnt/lib/init/rw
   mkdir -p /mnt/lib/init/rw/mdadm
   for dev in /dev/md/ddf* /dev/md/imsm*; do mdmon $dev; done
   switch_root /mnt /sbin/init

With the following links/files in place on the initrd:

   /sbin/mdadm     # statically linked
   /sbin/mdmon -> /mnt/sbin/mdmon
   /lib64/*.so    ->   /mnt/lib64/*.so        # libraries needed by the 
dynamically linked mdmon
   /var/run/mdadm -> /mnt/init/rw/mdadm
   /init/rw/mdadm -> /mnt/init/rw/mdadm

And the final system also has this:

   /var/run/mdadm -> /lib/init/rw/mdadm

So this approach allows me to run the final system's copy of mdmon, 
without ever having to use the '--takeover' stuff. And the mdmon 
"status" files are always in the same place. And /var can be unmounted 
during shutdown. Anything wrong with this? So far working fine for me...

Thanks,

Csaba Biegl
bieglc@bellsouth.net






mdmon.cmdline.crash.diff


diff --git a/mdmon.c b/mdmon.c
index 31d45fd..27dc8de 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -284,7 +284,7 @@ int main(int argc, char *argv[])
  				/* update cmdline so this mdmon instance can be
  				 * distinguished from others in a call to ps(1)
  				 */
-				if (strlen(devname)<= strlen(container_name)) {
+				if (container_name&&  (strlen(devname)<= strlen(container_name))) {
  					memset(container_name, 0, strlen(container_name));
  					sprintf(container_name, "%s", devname);
  				}
@@ -295,7 +295,7 @@ int main(int argc, char *argv[])
  		free_mdstat(mdstat);

  		return status;
-	} else if (strncmp(container_name, "md", 2) == 0) {
+	} else if (container_name&&  (strncmp(container_name, "md", 2) == 0)) {
  		devnum = devname2devnum(container_name);
  		devname = devnum2devname(devnum);
  		if (strcmp(container_name, devname) != 0)
@@ -304,7 +304,7 @@ int main(int argc, char *argv[])
  		struct stat st;

  		devnum = NoMdDev;
-		if (stat(container_name,&st) == 0)
+		if (container_name&&  (stat(container_name,&st) == 0))
  			devnum = stat2devnum(&st);
  		if (devnum == NoMdDev)
  			devname = NULL;
@@ -314,7 +314,7 @@ int main(int argc, char *argv[])

  	if (!devname) {
  		fprintf(stderr, "mdmon: %s is not a valid md device name\n",
-			container_name);
+			container_name ? container_name : "<missing>");
  		exit(1);
  	}
  	return mdmon(devname, devnum, do_fork(), takeover);

