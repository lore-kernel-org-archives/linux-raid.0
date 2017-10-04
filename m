From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Wed, 4 Oct 2017 15:15:17 -0400
Message-ID: <22997.13125.28017.852313@quad.stoffel.home>
References: <22997.8664.67459.119616@quad.stoffel.home>
        <576ad3c5-1c23-39d3-1631-d18ed0a3323a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <576ad3c5-1c23-39d3-1631-d18ed0a3323a@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Jes" == Jes Sorensen <jes.sorensen@gmail.com> writes:

Jes> On 10/04/2017 02:00 PM, John Stoffel wrote:
>> 
>> Since Eli had such a horrible experience where he shrunk the
>> individual component raid device size, instead of growing the overall
>> raid by adding a device, I came up with this hacky patch to warn you
>> when you are about to shoot yourself in the foot.
>> 
>> The idea is it will warn you and exit unless you pass in the --force
>> (or -f) switch when using the command.  For example, on a set of loop
>> devices:
>> 
>> # cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>> [raid4] [multipath] [faulty]
>> md99 : active raid6 loop4p1[4] loop3p1[3] loop2p1[2] loop1p1[1]
>> loop0p1[0]
>> 606720 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5]
>> [UUUUU]
>> 
>> # ./mdadm --grow /dev/md99 --size 128
>> mdadm: Cannot set device size smaller than current component_size of /dev/md99 array.  Use -f to force change.
>> 
>> # ./mdadm --grow /dev/md99 --size 128 -f
>> mdadm: component size of /dev/md99 has been set to 0K
>> 
>> 
>> I suspect I could do a better job of showing the original component
>> size, so that you have a chance of recovering even then.
>> 
>> But the patch:

Jes> Before looking at the actual code, some cosmetics

Sure, I'll re-spin the patch,  I have my emacs setup to use 4 spaces
for indentation, not 8 space tabs.  

>> @@ -1617,7 +1617,7 @@ int main(int argc, char *argv[])
>> else if (s.size > 0 || s.raiddisks || s.layout_str ||
>> s.chunk != 0 || s.level != UnSet ||
>> data_offset != INVALID_SECTORS) {
>> -			rv = Grow_reshape(devlist->devname, mdfd,
>> +		    rv = Grow_reshape(devlist->devname, mdfd, c.force,

Jes> Yikes!

Can you explain please?  I added in the c.force since that's the value
set by the -f (--force) flag when you call mdadm from the command
line.




