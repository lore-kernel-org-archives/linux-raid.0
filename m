From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm - raid6 best practices ?
Date: Fri, 22 Sep 2017 17:44:41 -0400
Message-ID: <22981.33865.311446.50850@quad.stoffel.home>
References: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
        <20170922182607.1977620-1-songliubraving@fb.com>
        <59C56381.3030704@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59C56381.3030704@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org, nkshirsa@redhat.com
List-Id: linux-raid.ids

>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:

Wols> On 22/09/17 19:26, Song Liu wrote:
>> I would say this is a tradeoff between space overhead (2 parity disks per
>> array) and data reliability (mean time before data loss, MTBDL, or MTTF).
>> Space overhead is easy to calculate. For MTBDL, there are various of
>> documents online, for example:
>> 
>> https://jontse.com/courses/files/cornell/ece5730/Lecture24.pdf
>> 
>> For your questions:
>> 
>>> a) recommended number of disks included in RAID array set?
>> I would personally recommend 12 to 15 HDDs per array.
>> 
Wols> My gut feel too was that 84 is an awful lot of disks ...

It really is... just do the math.  If you have 84 disks, and two of
them are parity, what's the rate of failures that gives you three disk
failures and them *boom* your data is gone.

Also, with that wide a stripe, you then have *horrible* performance
when you update a small 32k file, it has to read and re-write 81 disks
worth of data.  You're going to have horrible performance.

It would be smarter to have 12-16 disks in RAID6 pairs, then you could
either stripe or append to them.  I'd probably not even do that unless
I needed a single large volume.  The goal is to minimize data loss if
something goes wrong.

You also don't mention what filesystem(s) you've looked into for
this.  Or how you plan of sharing this disk space to other systems.
This is another area you need to be careful off.

Also, when you have this many disks in your system, which sounds like
one of the backblaze.com systems, you need to think about your
controllers and whether or not you're using expanders, etc.

If you're just going to maximum space for the least money, you could
just go with RAID0 and stripe data across the disks.  Pretty fast I
bet, but if you lose one... boom!  All gone.

You could do five 16 disk RAID6 arrays, leaving you with four hot
spares.  Then I'd probably just make them all seperate XFS
filesystems, especially since I don't know if you're using 4Tb disks
or some other size.

When you have this much space... it pays to be cautious, because users
will assume it's reliable and won't lose their data.

John
