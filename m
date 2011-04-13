From: David Brown <david@westcontrol.com>
Subject: Re: expand raid10
Date: Wed, 13 Apr 2011 14:34:15 +0200
Message-ID: <io454g$fq3$1@dough.gmane.org>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>	<BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com>	<BANLkTi=udXzNJwK9CKtK1QEqK1PznSp_2g@mail.gmail.com>	<20110413111015.GA10195@www2.open-std.org> <20110413211715.286d9203@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110413211715.286d9203@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/04/2011 13:17, NeilBrown wrote:
> On Wed, 13 Apr 2011 13:10:16 +0200 Keld J=F8rn Simonsen<keld@keldix.c=
om>  wrote:
>
>> On Wed, Apr 13, 2011 at 07:47:26AM -0300, Roberto Spadim wrote:
>>> raid10 with other layout i could expand?
>>
>> My understanding is that you currently cannot expand raid10.
>> but there are things in the works. Expansion of raid10,far
>> was not on the list from neil, raid10,near was. But it should be fai=
rly
>> easy to expand raid10,far. You can just treat one of the copies as y=
our
>> refence data, and copy that data to the other raid0-like parts of th=
e
>> array.  I wonder if Neil thinks he could leave that as an exersize f=
or
>> me to implement... I would like  to be able to combine it with a
>> reformat to a more robust layout of raid10,far that in some cases ca=
n survive more
>> than one disk failure.
>>
>
> I'm very happy for anyone to offer to implement anything.
>
> I will of course require the code to be of reasonable quality before =
I accept
> it, but I'm also happy to give helpful review comments and guidance.
>
> So don't wait for permission, if you want to try implementing somethi=
ng, just
> do it.
>
> Equally if there is something that I particularly want done I won't w=
ait for
> ever for someone else who says they are working on it.  But RAID10 re=
shape is
> a long way from the top of my list.
>

I know you have other exciting things on your to-do list - there was=20
lots in your roadmap thread a while back.

But I'd like to put in a word for raid10,far - it is an excellent choic=
e=20
of layout for small or medium systems with a combination of redundancy=20
and near-raid0 speed.  It is especially ideal for 2 or 3 disk systems.=20
The only disadvantage is that it can't be resized or re-shaped.  The=20
algorithm suggested by Keld sounds simple to implement, but it would=20
leave the disks in a non-redundant state during the resize/reshape.=20
That would be good enough for some uses (and better than nothing), but=20
not good enough for all uses.  It may also be scalable to include both=20
resizing (replacing each disk with a bigger one) and adding another dis=
k=20
to the array.

Currently, it /is/ possible to get an approximate raid10,far layout tha=
t=20
is resizeable and reshapeable.  You can divide the member disks into tw=
o=20
partitions and pair them off appropriately in mirrors.  Then use these=20
mirrors to form a degraded raid5 with "parity-last" layout and a missin=
g=20
last disk - this is, as far as I can see, equivalent to a raid0 layout=20
but can be re-shaped to more disks and resized to use bigger disks.




--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
