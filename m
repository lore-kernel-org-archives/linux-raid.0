From: David Brown <david@westcontrol.com>
Subject: Re: looking for advice on raid drives upgrade
Date: Wed, 30 Mar 2011 16:00:55 +0200
Message-ID: <imvd3u$bsr$1@dough.gmane.org>
References: <imuu5b$gaf$1@dough.gmane.org> <imvadk$q8j$1@dough.gmane.org> <4D9330CD.7090806@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9330CD.7090806@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/03/2011 15:31, Steven Haigh wrote:
> On 31/03/2011 12:14 AM, David Brown wrote:
>> If you've got a spare drive slot, and plenty of time, there is another
>> option that lets you keep online and redundant during the process.
>> Re-shape the array to raid 6, while adding one of the new drives. Then
>> you can replace each drive, one at a time, letting the raid recover in
>> between. For the last drive, you just have to remove it then reshape
>> back to raid 5 (although ideally you could buy an extra drive and keep
>> the raid 6 layout - it's worth the cost, assuming you have the drive
>> slot).
>>
>> Once everything is swapped over, you grow the array to fit the new disks.
>
> This makes me wonder... What is recommended as the best practice... Use
> the entire disk or 1 partition per device? Assuming of course that you
> won't be booting off the RAID5/6....
>

I think the answer depends on what you are trying to do.  If you are 
just building a single big array, then whole devices make most sense. 
But sometimes you want to try something more complicated (see my recent 
thread - though no one has yet said if it is a good idea...).  You may 
also want more than one array with different characteristics, such as 
the balance between capacity, speed (for different uses) and redundancy. 
  For example, you might think raid 5 is appropriate for some of your 
data, and raid10 for other parts.  By dividing each disk into two and 
using partitions from one half for one array, and the other half for the 
other array, you get both areas.  Clearly you'll get a performance hit 
if both arrays are used at the same time, but it's your choice.


