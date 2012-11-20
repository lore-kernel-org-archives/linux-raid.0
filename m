From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: Where can i download mdadm 3.3
Date: Tue, 20 Nov 2012 18:24:00 -0300
Message-ID: <CAGmni9oLLg1cFuf6shFkJd7D_CoSrx1u3f88QUqV6h2KEKNjJg@mail.gmail.com>
References: <CAGmni9ozPTrqeg+RLBu=J8NEqqK95nwf0ymK7qA7DgpZNRHX=A@mail.gmail.com>
 <20121120122622.34f9bacd@notabene.brown> <CAGmni9rKhsTS5hoBo2dFkcksyikS-STmPqagQhbsVC=CiB=54g@mail.gmail.com>
 <20121121071529.1d6bea7b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121071529.1d6bea7b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 20, 2012 at 5:15 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 20 Nov 2012 08:33:10 -0300 Salatiel Filho <salatiel.filho@gmail.com>
> wrote:
>
>> On Mon, Nov 19, 2012 at 10:26 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 18 Nov 2012 10:42:22 -0300 Salatiel Filho <salatiel.filho@gmail.com>
>> > wrote:
>> >
>> >> Hi guys, i will be building a few arrays very soon and i'd like to
>> >> test the badblock feature and the replaceable feature, but i haven`t
>> >> found where i can download the source of mdadm 1.3. Where can i get it
>> >> ?
>> >>
>> > You can't.  3.3 doesn't exist yet.
>> >
>> > However
>> >   git clone git://neil.brown.name/mdadm
>> >   cd mdadm
>> >   make
>> >
>> > will get you code that supports bad blocks and replaceable devices.
>> >
>> > Alternately you can get a tar file at
>> >
>> >    http://git.neil.brown.name/git?p=mdadm.git;a=snapshot;h=master
>> >
>> > NeilBrown
>>
>> Neil , now the question, how do i enable badblock list ?
>> # mdadm -A /dev/md1 /dev/sd[bcd]2 --update=bbl  ?
>
> Why not posted to the list?
>
> That looks right.  Did it work?
>
> NeilBrown


I forgot "reply to all" , sorry.

Yes, it worked. I was looking for some information with
# mdadm -D /dev/md1 and could not find.
but
#mdadm -E /dev/sdb2 shows me   Bad Block Log : 512 entries available
at offset 262128 sectors , so i think it is activated. Now i'm writing
to the array so my bad disk will show me some error.

I will report the progress as soon as the errors appear.
Thanks !


[]'s
Salatiel
