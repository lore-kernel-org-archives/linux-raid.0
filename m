From: Chris <cmtimegn@gmail.com>
Subject: Re: Raid 10 LVM JFS Seeking performance help
Date: Mon, 28 Dec 2009 13:23:20 -0800
Message-ID: <7eea85cf0912281323g2826c4fw31581ce23d21b8aa@mail.gmail.com>
References: <7eea85cf0912171549u58a4c64foc4cb96a388ddbd06@mail.gmail.com>
	 <87hbrko583.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hbrko583.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Right now we use no partitions so I MD the full disk.
Since my avrgq-sz is 8.0  What should I make my Chunk Size how do I
look into this more?
Over the holidays I did a Chunk Size of 32000 in f2 for testing but
that did not seem to work very well.  512 and 1024 Chunk size is what
I had before.  No matter the PE size and Chunk size my avgrq-sz is 8.
My real problem is just to even test one setup is about a week of
copying data and building the array.  That's why I am trying to get
anything to help me make a better guess to how to set this all up
right.

How do I check if I am seeking more than expected?

On Mon, Dec 21, 2009 at 4:56 AM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Chris <cmtimegn@gmail.com> writes:
>
>> I have a pair of servers serving 10MB-100MB files.=C2=A0 Each server=
 has
>> 12x 7200 SaS 750GB Drives.=C2=A0 When I look at iostat I see the avg=
rq-sz
>> is 8.0 always.=C2=A0 I think this has to do with the fact my LVM PE =
Size is
>> 4096 with JFS on top of that.=C2=A0=C2=A0=C2=A0 Best I can tell the =
fact I have so
>> many rrqm/s is not great and the reason I have that many is because =
my
>> avgrq-sz is 8.0.=C2=A0 I have been trying to grasp how I should come=
 up
>> with the best chunk and PE for more performance.
>>
>> Switch from n2 to f2 raid10?
>> How do I calculate where I need to go from here with Chunk Size and =
PE size?
>
> 2 far copies means each disk is split into 2 partitions, lets call
> them sda1/2, sdb1/2, ... Then sda1, sdb2 form a raid1 (md1) and sdb1,
> sdc2 form a second raid1 (md2), ..... Last md1, md2, ... are combined
> as raid0. That all is done internaly and more flexible. The above is
> just so you can visualize the layout. Writes will always go to sdX1
> and sd(X+1)2. Reads should always go to sdX1, which is usualy the
> faster part on rotating disks.
>
> You need to optimize the raid0 part and, probably way more important,
> the alignment of your data access. If everything is aligned nicely
> each request should be fully serviced by a single disk given your
> small request size. And the seeks should be evenly spread out between
> the disks with each disk seeking every 12 reads or twice every 6
> writes (or less). Check if you are seeking more than is expected.
>
> Also, on a lower level, make sure your raid does not start on a
> partition starting at sector 63 (which is still the default in many
> partitioning progs). That easily results in bad alignment causing 4k
> chunks to land on 2 sectors. But you need to test that with your
> specific drive to see if it really is a problem.
>
> MfG
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Goswin
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
