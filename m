From: Burn Alting <burn@goldweb.com.au>
Subject: Re: Hardware assisted parity computation - is it now worth it?
Date: Fri, 14 Jul 2006 09:43:19 +1000
Message-ID: <1152834199.26511.82.camel@swtf.comptex.com.au>
References: <1152778739.26511.65.camel@swtf.comptex.com.au>
	 <e9c3a7c20607131416u11f68581j87d5a6c02b2a5018@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20607131416u11f68581j87d5a6c02b2a5018@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2006-07-13 at 14:16 -0700, Dan Williams wrote:
> On 7/13/06, Burn Alting <burn@goldweb.com.au> wrote:
> > Last year, there were discussions on this list about the possible
> > use of a 'co-processor' (Intel's IOP333) to compute raid 5/6's
> > parity data.
> The MD patches have been posted for review, and the hardware offload
> pieces are nearing completion.
> 
> > We are about to see low cost, multi core cpu chips with very
> > high speed memory bandwidth. In light of this, is there any
> > effective benefit to such devices as the IOP333?
> It is true that upcoming server platforms have an abundance of CPU
> cycles, but what about the case where an IOP is the host processor?

Meaning? - the kernel thread processes the write up to the generation of
parity then it calls/initiates another thread to compute parity/etc and
then context switches waiting for a soft interrupt from the other
'parity compute' thread?

> This is the primary target of the current work.  Also, what about the
> more expensive RAID6 conditions (2-failed disks) where there might be
> benefits to having MD split its work over many CPUs?

Agreed. Hiving off the parity generation to some (perhaps persistent)
thread that would compute parity for you in the most effective way (ie
multiple cpu's) is a good idea.

My main question is not so much the re-working of the code to make
better use of CPU's but is there is a future for IOP's which have a much
slower memory bandwidth than that of the cpu cores. As I understand it
we will soon be looking at a 5 to 1 speed difference!

> 
> Regards,
> 
> Dan

Burn

