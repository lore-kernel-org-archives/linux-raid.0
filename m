From: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: Repeatable md OOPS on suspend,
 2.6.39.4 and 3.0.3
Date: Thu, 15 Sep 2011 09:32:10 +1000
Message-ID: <4E71397A.9060708@tuxonice.net>
References: <CALxPEfw-XdcosHemovkxj9aOwaYxUaQ6dj=yMaKCmoy2vkkUkg@mail.gmail.com>	<loom.20110901T032036-733@post.gmane.org>	<CALxPEfwJ99bvmSXkqSKutAYbcD9OLcyMcKQQO6G+Yxi9RQ1DFA@mail.gmail.com>	<CALxPEfyQrwWh1AWY-fwwCeMzDEeK390Eof9PwrsN6C11Wnt9=A@mail.gmail.com>	<loom.20110906T201030-97@post.gmane.org>
	<87mxed7u3s.fsf_-_@spindle.srvr.nix>
Reply-To: TuxOnIce users' list <tuxonice-users@lists.tuxonice.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070503060908090704000505"
Return-path: <tuxonice-users-bounces@lists.tuxonice.net>
In-Reply-To: <87mxed7u3s.fsf_-_@spindle.srvr.nix>
List-Unsubscribe: <http://lists.tuxonice.net/options/tuxonice-users>,
	<mailto:tuxonice-users-request@lists.tuxonice.net?subject=unsubscribe>
List-Archive: <http://lists.tuxonice.net/pipermail/tuxonice-users>
List-Post: <mailto:tuxonice-users@lists.tuxonice.net>
List-Help: <mailto:tuxonice-users-request@lists.tuxonice.net?subject=help>
List-Subscribe: <http://lists.tuxonice.net/listinfo/tuxonice-users>,
	<mailto:tuxonice-users-request@lists.tuxonice.net?subject=subscribe>
Sender: tuxonice-users-bounces@lists.tuxonice.net
Errors-To: tuxonice-users-bounces@lists.tuxonice.net
To: TuxOnIce users' list <tuxonice-users@lists.tuxonice.net>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070503060908090704000505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi.

Please try/review the attached patch.

The problem is that TuxOnIce adds a BUG_ON() to catch non-TuxOnIce I/O
during hibernation, as a method of seeking to stop on-disk data getting
corrupted by the writing of data that has potentially been overwritten
by the atomic copy.

Stopping the md devices from being marked readonly is the right thing to
do - if we don't resume, we want recovery to be run. If we do resume,
they should still be in the pre-hibernate state.

Regards,

Nigel

--------------070503060908090704000505
Content-Type: text/x-diff;
 name="md-reboot-mark-readonly.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="md-reboot-mark-readonly.patch"

diff --git a/drivers/md/md.c b/drivers/md/md.c
index af0e52c..25af0a8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8056,7 +8056,7 @@ static int md_notify_reboot(struct notifier_block *this,
 	struct list_head *tmp;
 	mddev_t *mddev;
 
-	if ((code == SYS_DOWN) || (code == SYS_HALT) || (code == SYS_POWER_OFF)) {
+	if (((code == SYS_DOWN) || (code == SYS_HALT) || (code == SYS_POWER_OFF)) && !freezer_state) {
 
 		printk(KERN_INFO "md: stopping all md devices.\n");
 

--------------070503060908090704000505
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
TuxOnIce-users mailing list
TuxOnIce-users@lists.tuxonice.net
http://lists.tuxonice.net/listinfo/tuxonice-users
--------------070503060908090704000505--
