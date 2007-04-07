From: Rich <rich@pcfusion.co.uk>
Subject: Re: LINEAR RAID, little help
Date: Sat, 07 Apr 2007 19:41:38 +0100
Message-ID: <4617E5E2.2090609@pcfusion.co.uk>
References: <46177DD8.9080707@pcfusion.co.uk> <20070407173352.GA23645@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070407173352.GA23645@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin McCullagh <gmccullagh@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gavin McCullagh wrote:
> Hi,
>
> The main reason I'm posting (given others can answer these questions
> better) is to ask a further question:=20
>
> Why would anyone use RAID-linear?  If RAID-0 gives better performance=
 for
> the same (reduced) reliability, what's the point of using Linear?  Do=
 you
> get slightly more space out of it?  I presume it's for stuff where yo=
u
> don't place much value no your data.
>
> On Sat, 07 Apr 2007, Rich wrote:
>
>  =20
>> I currently have a linear RAID setup via mdadm with is made up of 3=20
>> drives. I just have a few questions that I can't seem to find search=
ing=20
>> around on Google, etc.
>>    =20
>
> I must admit I've never used linear raid.  May I ask what made you ch=
oose
> it over say raid-0?
>  =20
Er, I went with Linear as reading around people seemed to recommend thi=
s=20
for odd sized drives (my old drives are 80's, 120 and 320's) also a rea=
d=20
somewhere that data on the other drives is more recoverable that most o=
f=20
the other RAID's.
>  =20
>> First question, what happens if one drive fails (I know I will loose=
 the=20
>> data on that drive) but how, if at all can I recover the data on the=
=20
>> other drives can I plug them in (on their own) as though they were i=
n=20
>> fact an individual drives? Do I need to execute a rebuild command in=
=20
>> mdadm at all to rebuild the array?
>>    =20
>
> http://tldp.org/LDP/EVMSUG/html/characraidlvls.html
>
> I'm sure someone else will give you a better answer but it would appe=
ar
> from these docs that your situation is similar to that of a person us=
ing
> RAID-0 who has a drive failure.  Basically, you end up with a big por=
tion
> of your filesystem data missing so you may lose everything.  I guess =
you
> might be able to recover some data using some filesystem recovery too=
ls but
> it's likely to be a pretty unreliable process and likely to vary from=
 one
> filesystem to the next.  It's probably a little more reliable than RA=
ID-0
> in that what's left is probably contiguous but I would certainly not =
want
> to rely on such a process for my data.
>
> The faq says similar "RAID-linear is a simple concatenation of partit=
ions
> to create a larger virtual partition. It is handy if you have a numbe=
r
> small drives, and wish to create a single, large partition. This
> concatenation offers no redundancy, and in fact decreases the overall
> reliability: if any one disk fails, the combined partition will fail.=
"
>
> http://tldp.org/HOWTO/Software-RAID-0.4x-HOWTO-2.html
>  =20
>> Second question, how can I go about adding a drive to my linear RAID=
, I
>> wish to add two new 500GB drives but I'm unsure how. I have found ho=
wto's
>> for RAID 5 but I just wanted to check it was a similar process for
>> Linear? Also this won't effect any data currently on the drive will =
it?
>>    =20
>
> You don't say what you're doing on this array, but before modifying i=
t, I'd
> be seriously inclined to question whether RAID-linear is really the r=
ight
> thing to be using at all.  Anyway, the mdadm manpage says=20
>  =20
Well it contains stuff like TV and films a lot of which my friends have=
,=20
so loosing it is not that big of a deal just inconvenient. As I said=20
before I read linear was a better choice for odd sized drives and had=20
better data recovery that the other RAID's
> "Currently the only support available is to
>  =B7 change the "size" attribute for RAID1, RAID5 and RAID6.
>  =B7 increase the "raid-disks" attribute of RAID1 and RAID5.
>  =B7 add a write-intent bitmap to any array which support these bitma=
ps, or
>    remove  a  write-intent bitmap from such an array."
>
> which suggests you can't.  That might be wrong though as it sounds (t=
o me
> anyway) like linear would be one of the easier ones to implement grow=
 for.
> I'm not sure.
>
> Gavin
>
>  =20

I'm sure I read somewhere on the mdadm page in one of the posts about=20
adding support for linear growing, and that was dated 2004 so it might=20
be in there? Just wasn't to sure how to do it...


Thanks,

Rich :)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
