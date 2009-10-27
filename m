From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 16:39:12 -0400
Message-ID: <7d86ddb90910271339ha3cf796g8fa58b798fd80dfd@mail.gmail.com>
References: <1256656849.15137.126.camel@poledra.romunt.nl>
	 <472064.4204.qm@web38802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472064.4204.qm@web38802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 27, 2009 at 4:31 PM, adfas asd <chimera_god@yahoo.com> wrot=
e:
> --- On Tue, 10/27/09, Rudy Zijlstra <rudy@grumpydevil.homelinux.org> =
wrote:
>> NFS/Samba are "bloated" as you call it, because
>
> In my opinion they are bloated because they are outmoded and ancient.=
 =A0FUSE instantly rendered them obsolete.
>
> So sine iSCSI is out my next avenue of investigation is clustering fi=
lesystems. =A0They should have the file-locking problem solved, and sho=
uld perform better than sshfs, much less NFS or SAMBA.

You need iSCSI to export the clustered file system. The only
difference is a clustered file system lets more than one computer
mount it. This should work in your situation, but you'll have to setup
fencing correctly.

Still in the end-user file sharing scenario SMB and NFS still are the
best methods. I'm not going to deal with a clustered file system for
hundreds of users. Fuse hasn't been widely adopted in the end-user
world especially with Windows clients, etc.

>
>
> --- On Tue, 10/27/09, Ryan Wagoner <rswagoner@gmail.com> wrote:
>> No NFS and Samba are not ancient bloatware. What other
>> protocol would
>> you use for a company file server? Rsync and SSH are not
>> replacements for group file sharing.
>
> As I say, sshfs. =A0Be officially turned on to FUSE and sshfs. =A0If =
you continue to decline, feel free to remain in the old-timey days gran=
dpa. =A0(PS, I'm 55)
>
>
> --- On Tue, 10/27/09, Bill Davidsen <davidsen@tmr.com> wrote:
>> What's the problem? You generate a list of file
>> checksums AND SIZES and
>> do some percentage of it daily, or all of it weekly, or
>> whatever
>> pleases you. And every time you change or add a file you
>> update the
>> checksum file on the master, and send it off to the backup
>> machine. Of
>> course you verify on the master as well as the backup, just
>> in case a
>> file is damaged on the master. The nice thing about this is
>> that it can
>> all be automated and can send you email saying that some
>> number of
>> files were checked and were okay, or were not okay.
>>
>> If it were my problem I would invest in two Gbit cards per
>> machine, two
>> *good* cables, and configure for jumbo frames. That gives
>> you over
>> 200MB/s transfer rate using rsync, runs over ssh by default
>> for
>> security, does checksums by default for reliability, should
>> give you a
>> nice safe copy which you can verify using the checksum
>> file.
>
> Very nice Bill, but I don't know the best way to go about these thing=
s. =A0This is why I keep asking for specifics. =A0Maybe if you pretend =
that I'm a dumb real estate developer...
>
>
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
