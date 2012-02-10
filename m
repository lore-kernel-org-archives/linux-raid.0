From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: add another disk to existing raid 0, ie grow raid 0 possible?
Date: Fri, 10 Feb 2012 16:10:09 +0200
Message-ID: <4F352541.2050207@oldum.net>
References: <4F212A59.1070008@oldum.net>	<CADNH=7GXJ0DW7K5DqSgoYYsa2eSWzE9P46R=Qrehu1pFXqnpyQ@mail.gmail.com>	<20120126215713.0c24db62@notabene.brown>	<4F21396D.7030308@oldum.net> <20120209145054.4443a48b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120209145054.4443a48b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Neil,
Do you think it will make sense to try to replicate using loop devices?

Cheers,
- -Nik

On 02/09/2012 05:50 AM, NeilBrown wrote:
> On Thu, 26 Jan 2012 13:30:53 +0200 Nikolay Kichukov <hijacker@oldum.net>
> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
> 
>> Hello Neil,
> 
>> Here goes the details. Once again, no valuable data, just curious what has gone wrong in that case:
> 
>> dmesg output, first I stopped md2, then assembled it again to perform the grow.
>> http://pastebin.com/HkPVEKad
> 
>> mdadm -E output:
>> http://pastebin.com/pJCjvrJE
> 
>> The system runs GNU/Debian testing with latest updates from security-testing applied.
>> Kernel: 3.1.0-1-amd64
>> mdadm:  3.2.2-1
> 
>> Let me know should you need any further information.
> 
> I've finally had a look at this and unfortunately cannot find the problem.
> The main reason being that I cannot reproduce it.
> I built the same kernel and mdadm and created a very similar array and
> tried to grow it and it all went smoothly.
> 
> In your case it didn't start the reshape at all (reshape position was zero) so
> something went wrong very early.
> 
> If you feel like trying to reproduce it again that might be helpful.
> Then I would ask you to run the "mdadm --grow" command under 
>     strace -o /tmp/foo -f mdadm --grow ....
> 
> and send me the /tmp/foo.  But I won't be surprised if you cannot reproduce.
> Sad really.
> 
> Thanks anyway,
> NeilBrown
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPNSVBAAoJEDFLYVOGGjgX6b8H/28J1Ju3ccFq5awOnErcrqMP
eaIwiZx6MNLObHliPdycISqjQdvEy5TcGPr5bL+WbLqkPEhe4OVkQm6mOwHoup/1
p0YuhOpsxMihkLwuZWL2bYKhd4Jg29fT4sXgjdDSYyqyuxvSowr+CI/EhuYzuuHr
fiw4YDM8mCNRjhd6Z10IwbpdUujoL5hNTrmXSqHZGaCfvyxK5Bjwl9DNyXc7k9Pt
seryw/hJwTIsCBnmjFZ4XlgLpKNTCIK7TPNsrAJ50UOkXRVBBeEGuUg+rIQe+07T
0bja5MAHA9YgDofvSY4HFl3EYpo6hQy69QrO0bY6gwJ9VPkYxmRwZCELiV2fQsM=
=Sebf
-----END PGP SIGNATURE-----
