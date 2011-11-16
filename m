From: Hank Barta <hbarta@gmail.com>
Subject: Re: raid startup on a live CD?
Date: Tue, 15 Nov 2011 21:24:20 -0600
Message-ID: <CABTDG8_4-DDcHJXAyp-tYPKY+BoVRPgZoFWfwpmHirzZ_S_-gg@mail.gmail.com>
References: <CABTDG88XS6HeGbhj1=iApvsFfifbdjLrO-eoJ4TxNcEcNoyRQg@mail.gmail.com>
	<20111115160358.5653769c@notabene.brown>
	<CABTDG8-aV0q0_TF3LV2eDcXNU-jrW0atftMToo+wrM=7LtRkLw@mail.gmail.com>
	<20111116081501.05c451e5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111116081501.05c451e5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes - many thanks for your help with this.

Actually it was /etc/mdadm/mdadm.conf and it did define those three
RAIDS. I will pass that info along to the developer of this distro.

The command you suggested did start all of my RAID partitions.

thanks again,
hank


On Tue, Nov 15, 2011 at 3:15 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 15 Nov 2011 14:51:51 -0600 Hank Barta <hbarta@gmail.com> wrot=
e:
>
>> Here is a copy of the session.
>
> Thanks.
>
> It looks like you have an /etc/mdadm.conf file which lists /dev/md2,
> /dev/md0 and /dev/md1 and has uuids for them which do not match the u=
uids of
> any devices that are found.
>
> Does the boot cd have /etc/mdadm.conf (or /etc/mdadm/mdadm.conf) ??
>
> Try:
>
> =A0mdadm --assemble --scan --verbose --config=3Dpartitions
>
> That will cause it to ignore and mdadm.conf file.
>
> NeilBrown
>
>
>>
=2E..

--=20
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
