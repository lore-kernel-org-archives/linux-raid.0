From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 14:22:43 -0400
Message-ID: <7d86ddb90910271122p74827d2dr58de8bec9e20ef42@mail.gmail.com>
References: <20091027143630.GF5585@boogie.lpds.sztaki.hu>
	 <235564.59062.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <235564.59062.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 27, 2009 at 10:40 AM, adfas asd <chimera_god@yahoo.com> wro=
te:
> --- On Tue, 10/27/09, Gabor Gombas <gombasg@sztaki.hu> wrote:
>> > Thanks. =A0But what I have in mind is serving the
>> HTPC's array (with
>> > videos)to the storage server via iSCSI.
>> Hopefully the array can be
>> > mounted on the HTPS and still be served to the remote
>> storage server
>> > by iSCSI?
>>
>> No. You either mount the fs locally _or_ export it via
>> iSCSI. You can't
>> do both simultaneously. If you want to access the files
>> from both
>> locations, you have to use NFS or Samba (or a distributed
>> file system,
>> but that's IMHO way too complicated for your setup).
>
> Oh no. =A0Well I don't see the point of iSCSI then.

iSCSI is a block level protocol while NFS and Samba work at the file
level. They all have their specific uses and advantages /
disadvantages.

>
> I wouldn't even consider NFS or Samba because they are ancient bloatw=
are. =A0I gather from a prior post that rsync has a remote ssh function=
=2E =A0If that's not the case then I guess it has to be sshfs.

No NFS and Samba are not ancient bloatware. What other protocol would
you use for a company file server? Rsync and SSH are not replacements
for group file sharing.

Just use rsync over SSH. Simple and reliable.

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
