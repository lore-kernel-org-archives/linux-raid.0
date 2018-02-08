From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: RFC - de-clustered raid 60 or 61 algorithm
Date: Thu, 8 Feb 2018 23:10:14 +0000
Message-ID: <81626593-c835-315f-3247-3019d81491a0@youngman.org.uk>
References: <9f9e737c-d6d1-5cce-8190-14d970320265@youngman.org.uk>
 <876078maui.fsf@notabene.neil.brown.name>
 <e7c2c26c-c59b-ebab-423d-683a05ddfd8c@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e7c2c26c-c59b-ebab-423d-683a05ddfd8c@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/02/18 12:56, Phil Turmel wrote:
> On 02/07/2018 10:14 PM, NeilBrown wrote:
>> On Thu, Feb 08 2018, Wol's lists wrote:
> 
>>> I've been playing with a mirror setup, and if we have two mirrors, we
>>> can rebuild any failed disk by coping from two other drives. I think
>>> also (I haven't looked at it) that you could do a fast rebuild without
>>> impacting other users of the system too much provided you don't swamp
>>> i/o bandwidth, as half of the requests for data on the three drives
>>> being used for rebuilding could actually be satisfied from other drives.
>>
>> I think that ends up being much the same result as a current raid10
>> where the number of copies doesn't divide the number of devices.
>> Reconstruction reads come from 2 different devices, and half the reads
>> that would go to them now go elsewhere.
> 
> This begs the question:
> 
> Why not just use the raid10,near striping algorithm?  Say one wants
> raid6 n=6 inside raid60 n=25.  Use the raid10,near6 n=25 striping
> algorithm, but within each near6 inner stripe place data and P and Q
> using the existing raid6 rotation.
> 
> What is the more complex placement algorithm providing?
> 
It came from the declustered thread.

Especially with raid-60, a rebuild will hammer a small subset of the 
drives in the array. The idea is that a more complex algorithm will 
spread the load across more drives. If your raid-6 in a raid-60 has say 
8 drives, a rebuild will stress 16 drives. If you've got 100 drives 
total, that's a lot of stress that could be avoided if the data could be 
more widely spread.

Thing is, you CAN gain a lot from a complex raid like raid-60 which you 
lose with a raid-6+0 - again something that came up was you have to 
scrub a raid-6+0 as a whole bunch of separate arrays.

Really, it's a case of the more we can spread the data, it (1) reduces 
the stress during a rebuild, thus reducing the risk of a second related 
failure, and (2) it increases the chances of surviving a multiple drive 
failure because if three logically related drives fail you've lost your 
raid-6-based array. Spreading the data reduces the logical linking 
between drives.

Cheers,
Wol
