From: David Greaves <david@dgreaves.com>
Subject: Re: Using LVM for RAID 1+0
Date: Wed, 19 Apr 2006 22:06:47 +0100
Message-ID: <4446A667.5080003@dgreaves.com>
References: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>	 <17477.35448.136382.373967@cse.unsw.edu.au>	 <6d5bedd80604181919o350b715dm1d715d0be01f3c6@mail.gmail.com>	 <17477.42182.423594.547630@cse.unsw.edu.au> <6d5bedd80604191340j1bb09f03t4ef1fc765064bf11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd80604191340j1bb09f03t4ef1fc765064bf11@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ewan Grantham wrote:
> On 4/18/06, Neil Brown <neilb@suse.de> wrote:
>   
>> No, you cannot grow an md/raid0 array.  If you need growth, then you
>> would need to consider LVM at this stage, though md/linear will
>> probably be able to grow soon.
>>     
>
> Any chance RAID-5 will be able to grow at some point also?
Truly courageous :)

Kidding!!


raid5 can grow already - both size of disks (ie replacing each existing
disk with a bigger one) and more recently, number of disks.

There's not been much traffic about it - but what there has been has
been good.

You'll need a very recent kernel/mdadm though... and a backup is always
recommended.

David
PS I'm not talking about raidreconf - that has generated some 'doh!'
messages

-- 

