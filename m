From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: [OT] C programming problem
Date: Wed, 7 Feb 2018 23:32:55 +0000
Message-ID: <12c4cfa3-4131-0ecb-8277-4927ba89461d@youngman.org.uk>
References: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
 <ab1b1454-8226-ceab-55c8-e105fd0b3ca6@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ab1b1454-8226-ceab-55c8-e105fd0b3ca6@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/02/18 22:43, Phil Turmel wrote:
> Hi Wol,
> 
> Bug alert!
> 
> On 02/07/2018 02:46 PM, Wol's lists wrote:
>> void main()
>> {
> 
>>      blocks = logdisks * mirrors * disks;
>>      array = (int *) malloc( sizeof(int) * blocks );
>>      memset( &array, 0, blocks * sizeof(int) );
>                ^^^^^^
> 
> Your 'array' variable is already a pointer.  You should not have
> another address-of operator in front of it.  You are overwriting
> your pointer and a bunch of static memory right after it, not
> zeroing the area pointed to by 'array'.
> 
Thanks. Somebody else already pointed out the error, but he was rather 
more "teacher", didn't tell me what exactly it was, and let me find it 
for myself!

Stupid mistake, but as I said, my C-fu is rusted solid :-)

Anyways, I've now got it sorted - I'll probably be posting it to the 
list as an RFC very soon ...

Cheers,
Wol
