From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Mon, 11 Nov 2013 09:52:51 +0200
Message-ID: <6DC2162E-B592-4183-B645-71BC8AC21C76@gmail.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com> <527FDBC1.4000009@hardwarefreak.com> <D691C632-1025-4D32-9138-55BF9DE47300@gmail.com> <527FE89A.4010608@hardwarefreak.com> <89667845-9A4C-4402-91BE-0817BCB02C6F@gmail.com> <52805251.2010102@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52805251.2010102@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 11, 2013, at 5:43 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

>> What about filesystem state? Does it matter if a filesystem is mounted when check is run?
> 
> I'm not an EXT user.  See "man e2fsck".
> 
> With XFS you can check while mounted using "xfs_repair -n [device]", but
> no repairs will be performed, you simply get a report.  To repair a
> damaged XFS filesystem use the same command sans "-n" on the unmounted
> filesystem.  xfs_repair will abort if the filesystem is mounted, and
> "-n" is not specified.  xfs_repair is not to be automated via
> script/cron.  It is only to be run if/when errors are encountered,
> usually after a crash, power loss, controller failure, etc.

Oh, I meant 'check' as in

echo check > /sys/block/$DEVICE/md/sync_action

That, and I also read on my distro's wiki that 'check' will pick up where it was interrupted automatically in those cases when a system is rebooted before 'check' is complete. Well, apparently it does not work that way because I was only some 4% into 'check' yesterday evening, and after resume from sleep mdstat does not show that 'check' is running. So, does the distro's wiki contain erroneous information?

Ivan