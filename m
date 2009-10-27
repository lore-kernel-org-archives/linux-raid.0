From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 17:00:06 -0400
Message-ID: <7d86ddb90910271400m6d0c5a76n7af4d99bedf66bfc@mail.gmail.com>
References: <4AE75BDB.1020908@tmr.com>
	 <577070.18599.qm@web38807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <577070.18599.qm@web38807.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 27, 2009 at 4:53 PM, adfas asd <chimera_god@yahoo.com> wrot=
e:
> You're not understanding.
>
> I plan for the **storage server** to mount the RAID0 volume on the HT=
PC (shared), so the **storage server** can do all backup and checking o=
perations. =A0This should be a job for the storage server, not the HTPC=
=2E =A0The HTPC should/will perform all video duties.

I think you are way over complicating this. NFS would do this with a si=
ngle line

On the HTPC you add to /etc/exports the following line (replace things
appropriately) and start nfs
/data 192.168.1.10 (rw,async,no_root_squash)

Then on the storage server mount the nfs export
mount htpc:/data /local/path

>
> And NFS/Samba are out. =A0O-U-T, OUT. =A0Old-and-busted. =A0Useful li=
ke a washboard. =A0Many years ago I vowed that I would never learn two =
things: =A0automatic transmissions, and NFS. =A0I did learn and use Sam=
ba for some years, but now it is old-and-busted. =A0sshfs has served me=
 well over the past year and a half, under rigorous conditions. =A0It i=
s limited though by CPU consumption for encryption. =A0This is why I wi=
ll investigate clustering filesystems and FUSE options.
>
>
> --- On Tue, 10/27/09, Bill Davidsen <davidsen@tmr.com> wrote:
>> One more time, if you mount the backup copy on the main
>> server it will then be subject to the same failure issues as
>> a mirror. You want to use something like rsync to backup
>> over network, and the function of the backup server isn't
>> going to be to serve other than in case of emergency. You
>> don't want to serve, to mount, to do anything which will let
>> filesystem, OS, or user errors propagate to the backup
>> copy.
>>
>> Other than the reliability issue if you mount, there's no
>> reason to avoid things like NFS, they are well tested but
>> not stagnant, getting significant upgrades a few years ago
>> and regular minor glitch fixes for corner cases. In general
>> cutting edge and reliable is not the most probable
>> combination. While NFS is widely used and maintained,
>> protocols like AFS, iSCSI and sshfs are used by fewer sites,
>> and perhaps more experienced administrators, so perhaps they
>> are less tested, particularly in the area of less than
>> optimal setup.
>>
>> Boring and uneventful is what you want in a backup system.
>>
>> -- Bill Davidsen <davidsen@tmr.com>
>> =A0Unintended results are the well-earned reward for
>> incompetence.
>>
>>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
