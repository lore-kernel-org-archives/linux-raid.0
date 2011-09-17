From: David Brown <david.brown@hesbynett.no>
Subject: Re: additional feature for linear
Date: Sat, 17 Sep 2011 17:47:37 +0200
Message-ID: <j52fep$jj2$1@dough.gmane.org>
References: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>	<6385457414268580907@unknownmsgid> <CAC_HdUrFADb1G-5cos4foKohv8B=B0-pA=O8nbGnSX4z7mWcKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC_HdUrFADb1G-5cos4foKohv8B=B0-pA=O8nbGnSX4z7mWcKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/09/11 17:32, Henti Smith wrote:
> On Sat, Sep 17, 2011 at 5:20 PM, J=E9r=F4me Poulin<jeromepoulin@gmail=
=2Ecom>  wrote:
>> On 2011-09-17, at 03:14, Henti Smith<henti@geekware.co.za>  wrote:
>>
>>> Would it not be possible to add functions to linear mode to mark th=
is
>>> missing chunks as "bad blacks" and let the FS deal with it as such.
>>
>> Linux RAID can already deal with such a problem IIRC but if the
>> filesystem superblock is missing or directory entries, you ain't goi=
ng
>> no where. This kind of feature would require filesystem knowledge of
>> where the RAID split the device and would be better suited to a FS
>> like BTRFS which mirror superblock and metadata without any Linux
>> RAID.
>
> Hi J=E9r=F4me
>
> Thanks for the reply. I though BTRFS would be a good option as well,
> but they don't seem to understand what I'm looking for :)
>
> I have found a fuse base FS that seems to do this, so will play with =
that.
>
> It's called http://romanrm.ru/en/mhddfs and seems to do what I need i=
t
> to do so will test :)
>
> Thanks again for replying.
>
> Henti


That looks like an interesting idea, and would be particularly useful i=
f=20
you've already got several disks with filesystems and want to join them=
=20
together.  However, I would never consider it for a /new/ setup.  The=20
price of disk space is so low that I never again expect to set up a=20
computer without raid, unless it is a laptop with only space for one=20
disk, or a machine using some nameless inferior operating system that=20
doesn't support proper raid.  Certainly if you are thinking of putting=20
three disks in a machine then raid10,far would be the natural choice, o=
r=20
raid5 if you want a little more space for your pennies.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
