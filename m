From: Phil Turmel <philip@turmel.org>
Subject: Re: md: kicking non-fresh sdf3 from array!
Date: Thu, 27 Dec 2012 15:25:17 -0500
Message-ID: <50DCAEAD.3090205@turmel.org>
References: <CAK2H+effDWFWP32wO4vXPSQ16tgZKdBwvQRRiq+Qpy03VCE6xA@mail.gmail.com> <50DCA819.80809@turmel.org> <CAK2H+ecBALbrpshYQ5TZhuOJh_kgXqi_C90Zp-FtCgaE4dEgSw@mail.gmail.com> <50DCAE69.1080003@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50DCAE69.1080003@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Whoops!  The list was dropped...

On 12/27/2012 03:24 PM, Phil Turmel wrote:
> On 12/27/2012 03:20 PM, Mark Knecht wrote:
>> Thanks Phil,
>>    I've added the device back in and the rebuild is proceeding.
>>
>>    So the new piece of info here for me is this idea of a bitmap. I'll
>> have to go look into that, but a quick question - is that something
>> that can be added to the RAID6 at this time, or can you only do that
>> when you first build it? As I have some issue with my (possibly)
>> initramfs I expect I'll kick the devices a few more times before I get
>> it worked out. Would be nice if putting the disk back in didn't take
>> so long.
> 
> You can add a bitmap to any v1.x array after the fact with "--grow".  It
> does add a little overhead to the write path, so you might not want it
> in a heavily loaded server.  For a test-bed or other system prone to
> crashes, it's a godsend.
> 
> Phil
> 

