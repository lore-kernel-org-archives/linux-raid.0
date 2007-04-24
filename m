From: David Greaves <david@dgreaves.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing
 assembly.
Date: Tue, 24 Apr 2007 09:32:48 +0100
Message-ID: <462DC0B0.9010105@dgreaves.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>	 <462CF303.6030004@dgreaves.com>	 <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com> <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leon Woestenberg wrote:
> On 4/24/07, Leon Woestenberg <leon.woestenberg@gmail.com> wrote:
>> Hello,
>>
>> On 4/23/07, David Greaves <david@dgreaves.com> wrote:
>> > There is some odd stuff in there:
>> >
>> [root@localhost ~]# mdadm -v --assemble --scan
>> --config=/tmp/mdadm.conf --force
>> [...]
>> mdadm: no uptodate device for slot 1 of /dev/md0
>> mdadm: no uptodate device for slot 2 of /dev/md0
>> [...]
>>
> So, the problem I am facing is that the slot number (as seen with
> --examine) is invalid on two and therefore they won't be recognized as
> valid drives for the array.
> 
> Is there any way to override the slot number? I could not find
> anything in mdadm or mdadm.conf to override them.
Yes --create, see my original reply.

Essentially all --create does is create superblocks with the data you want (eg
slot numbers). It does not touch other 'on disk data'.
It is safe to run the *exact same* create command on a dormant array at any time
after initial creation - the main side effect is a new UUID.
(Neil - yell if I'm wrong).

The most 'dangerous' part is to create a superblock with a different version.

If you wanted to experiment (maybe with loopback devices) you could try
--create'ing an array with 4 devices to simulate where you were.
Then do the --create again with 2 devices missing. This should end up with 2
devices with one UUID, 2 with another.

Then do an --assemble using --force and --update=uuid.

Report back if you do this...

Cheers
David


