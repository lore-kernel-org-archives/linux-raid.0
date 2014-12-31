From: "John Stoffel" <john@stoffel.org>
Subject: Re: Re: =?iso-8859-1?Q?Re=A0:?= Re: Big trouble during reassemble a Raid5
Date: Wed, 31 Dec 2014 11:08:31 -0500
Message-ID: <21668.8063.635941.184463@quad.stoffel.home>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
	<21665.40484.909891.197506@quad.stoffel.home>
	<164935924.13594562.1419881845418.JavaMail.zimbra@laposte.net>
	<21665.47943.879001.195325@quad.stoffel.home>
	<84D72604-6572-40D9-8861-19B28BBF91B6@laposte.net>
	<21667.5112.568800.563410@quad.stoffel.home>
	<367813595.16604641.1420034830100.JavaMail.zimbra@laposte.net>
	<21668.1236.130012.995660@quad.stoffel.home>
	<2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: sylvain.depuille@laposte.net
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


sylvain> It's my fault too, because the mailing list doesn't accept
sylvain> HTML format.  And my provider doesn't offer plain text option
sylvain> with the mobile site :-(

It's a total pain at times.  I'm still reading email with plain ascii
most of the time, I don't care for HTML email generally since it just
gets in the way.  

sylvain> Back to the issue :

sylvain> I have stop the raid.
sylvain> mdadm --stop /dev/md2
sylvain> mdadm: stopped /dev/md2

sylvain> cat /proc/mdstat
sylvain> Personalities : [raid1] [raid6] [raid5] [raid4] 
sylvain> unused devices: <none>

sylvain> And when i try to re-assemble, the command is aborting :
sylvain> mdadm --assemble --force /dev/md2 /dev/sd[bcde]1
sylvain> mdadm: /dev/md2 assembled from 2 drives and 1 spare - not enough to start the array.

So if I look at the event counts, there's a mismatch between
/dev/sd[bde]1 and /dev/sdc1.  So let's try to assemble without /dev/sdc1:

  mdadm -vv --assemble --force /dev/md2 /dev/sdb1 missing /dev/sdd1 /dev/sde1

and see what happens then.  With three out of the four devices, the
RAID5 array should start up, and then you can add in /dev/sdc1 to
rebuild the parity.

John
