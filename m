From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Sat, 08 Aug 2009 16:24:44 +0100
Message-ID: <4A7D98BC.4050404@anonymous.org.uk>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop>	<4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop>	<4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>	<4A7B708F.4050406@uga.edu>	<20090807035303.GA31754@musti.tarvainen.info>	<87vdkzp0rk.fsf@frosties.localdomain>	<24aa235266d4cb2161954c4d49ed8ebe.squirrel@neil.brown.name> <87ocqqvipy.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ocqqvipy.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: NeilBrown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/08/2009 08:59, Goswin von Brederlow wrote:
> "NeilBrown" <neilb@suse.de> writes:
>> On Sat, August 8, 2009 11:11 am, Goswin von Brederlow wrote:
[...]
>>> On the other hand don't forget that raid1 is buggy with swap and the
>>> page contents might change between writes to the first and second
>>> disk. Or has that been fixed?

Can you give a reference for this?

>> There is no bug here.  The behaviour is a little unexpected
>> but it is perfectly "correct" in that there is never any risk to
>> data.
> 
> Disk 1 writes, page is modified, disk 2 writes, page is swapped in
> from disk 1, something crashes because old data is swapped in.
> 
> Or did I miss something?

If the page is modified then it won't be swapped back in when you said, 
because the swap out wasn't completed and the page wasn't reallocated. 
Well, that's my guess. I presume this is allowed for performance reasons.

Cheers,

John.
