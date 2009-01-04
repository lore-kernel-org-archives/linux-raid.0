From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Sun, 04 Jan 2009 13:49:23 +0000
Message-ID: <4960BE63.3040608@anonymous.org.uk>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>	<49580061.9060506@yahoo.com>	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>	<yq13ag174af.fsf@sermon.lab.mkp.net>	<495F6622.9010103@anonymous.org.uk> <yq1eizj5xos.fsf@sermon.lab.mkp.net> <4960AC15.8030207@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4960AC15.8030207@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/01/2009 12:31, John Robinson wrote:
> On 04/01/2009 07:37, Martin K. Petersen wrote:
[...]
>> We also don't want to do checksumming at every layer.  That's going to
>> suck from a performance perspective.  It's better to do checksumming
>> high up in the stack and only do it once.  As long as we give the upper
>> layers the option of re-driving the I/O.
>>
>> That involves adding a cookie to each bio that gets filled out by DM/MD
>> on completion.  If the filesystem checksum fails we can resubmit the I/O
>> and pass along the cookie indicating that we want a different copy than
>> the one the cookie represents.
> 
> I'd like to understand this mechanism better; at first glance it's 
> either going to be too simplistic and not cover the various block layer 
> cases well, or it means you end up re-implementing RAID and LVM in the 
> filesystem.

I've thought about this again, and I'm wrong; there may be complications 
in handling the cookies up and down the stack where more than one layer 
thinks it knows how to have another go, but I can see what you describe 
as being useful and relatively device-agnostic.

I wonder if there might also be scope for cookies going down through the 
stack to carry an indication of how hard to try; some filesystems or 
other consumers of block devices may be willing to ask again or want to 
be told about problems quickly (e.g. btrfs over RAID over TLER-equipped 
discs), while some may need best efforts all out first time because they 
can't cope will failure returns (e.g. FAT over cheap IDE discs).

Anyway, I think I'd better leave all this to the experts i.e. you :-)

Cheers,

John.

