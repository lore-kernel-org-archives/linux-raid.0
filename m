From: chris <tknchris@gmail.com>
Subject: Re: Weird Issue with raid 5+0
Date: Sun, 21 Feb 2010 02:26:42 -0500
Message-ID: <31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
	 <20100221164805.5bdc2d60@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100221164805.5bdc2d60@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That is exactly what I didn't want to hear :( I am running
2.6.26-2-xen-amd64. Are you sure its a kernel problem and nothing to
do with my chunk/block sizes? If this is a bug what versions are
affected, I'll build a new domU kernel and see if I can get it working
there.

- chris

On Sun, Feb 21, 2010 at 12:48 AM, Neil Brown <neilb@suse.de> wrote:
> On Sat, 20 Feb 2010 23:33:23 -0500
> chris <tknchris@gmail.com> wrote:
>
>> Hello,
>>
>> I am trying to setup a raid 5+0 on 6 1TB sata disks. I created the
>> arrays like so:
>>
>> mdadm --create /dev/md2 --level=3D5 --raid-devices=3D2 /dev/sda /dev=
/sdb /dev/sdc
>> mdadm --create /dev/md3 --level=3D5 --raid-devices=3D2 /dev/sdd /dev=
/sde /dev/sdf
>> mdadm --create /dev/md4 --level=3D0 --raid-devices=3D2 /dev/md2 /dev=
/md3
>>
>> The arrays create and sync fine, then I put lvm on top and create a
>> volume group and everything seems fine. I created 2 logical volumes
>> and formatted them with filesystems and initially didn't realize
>> anything was wrong. After running 2 virtual machines on them for a
>> while =A0I noticed the vm's were reporting bad blocks on the volume.=
 I
>> looked in the dom0 dmesg and found tons of messages such as:
>>
>> [444905.674655] raid0_make_request bug: can't convert block across
>> chunks or bigger than 64k 69314431 4
>
> This looks like a bug in 'dm' or more likely xen.
> Assuming you are using a recent kernel (you didn't say), raid0 is
> receiving a request that does not fit entirely in on chunk, and
> which has more than on page in the bi_iovec.
> i.e. bi_vcnt !=3D 1 or bi_idx !=3D 0.
>
> As raid0 has a merge_bvec_fn, dm should not be sending bios with more=
 than 1
> page without first cheking that the merge_bvec_fn accepts the extra p=
age.
> But the raid0 merge_bvec_fn will reject any bio which does not fit in
> a chunk.
>
> dm-linear appears to honour the merge_bvec_fn of the underlying devic=
e
> in the implementation of its own merge_bvec_fn. =A0So presumably the =
xen client
> is not making the appropriate merge_bvec_fn call.
> I am not very familiar with xen: =A0how exactly are you making the lo=
gical
> volume available to xen?
> Also, what kernel are you running?
>
> NeilBrown
>
>
>>
>> Chunksize for both raid5's and the raid0 is 64k so it would appear t=
he
>> issue is not that the chunk size is greater than 64k. I also find it
>> hard to believe it could be any kind of lvm issue simply because the
>> message in dmesg clearly shows its related to the raid0.
>>
>> Any ideas on what I'm missing here would be greatly appreciated. I
>> would imagine it is some kind of alignment between block and chunk
>> sizes but I can't seem to figure it out :)
>>
>> More detailed information including raid information and errors is a=
t
>> http://pastebin.com/f6a52db74
>>
>> - chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
