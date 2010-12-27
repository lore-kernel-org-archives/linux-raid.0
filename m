From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Is It Hopeless?
Date: Tue, 28 Dec 2010 05:34:33 +0800
Message-ID: <4D190669.8040809@wasp.net.au>
References: <201012261019.56481.CACook@quantum-sci.com> <201012261606.29281.CACook@quantum-sci.com> <4D182587.4040801@turmel.org> <201012270510.51520.CACook@quantum-sci.com> <4D18AAE0.40700@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D18AAE0.40700@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Carl Cook <CACook@quantum-sci.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/12/10 23:04, Phil Turmel wrote:
> On 12/27/2010 08:10 AM, Carl Cook wrote:
>>> Every time I read/hear this I cringe.  If that is the case your data is worthless to begin with so just delete it all right now.  You are literally saying the same thing with your statement.
>>
>> No, I'm saying that the MTBF of disk drives is astronomical, and the likelihood of a fail during backup is miniscule.  MTBF of tape is hundreds of times sooner.  Not to mention that tape would take forever, and require constant tending.  This is why it's not used anymore.  My storage is 2TB now, but my library is growing all the time.  Backing to off-line disk storage is the only practical way now, given the extremely low cost and high capacity and speed.  Each WD 2TB drive is $99 from Newegg!  Astounding.  Thanks for the input though.
>>
>>
>> On Sun 26 December 2010 21:35:03 Phil Turmel wrote:
>>> I, too, use an alternate server to back up to, but my daily changes are small enough to rsync over the net.  To reduce the chance of double failures in my arrays, a cron job kicks off a "resync" weekly.
>>
>> Can you please give some detail on your sync scripts?  I've never done this and am not a programmer, but I'm a pretty good shade-tree admin.
>
> Sure.  Attached.  Note that the script doesn't set the sysctls for speed limits...  The defaults are fine for me.

Hrm.. I used to do this too, until a silent corruption issue with a controller trashed 8TB of data. 
Now if I'd done a "check" instead of a repair, and been alerted to the fact the controller was 
corrupting data rather than blindly overwriting the parity blocks I'd have had a chance of saving 
the array.

Checksum and test regularly!.

I do have a backup regime, however I do a full rotation every 3 months and it was approximately 3 
months and 5 days before I noticed I really had a problem.

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
