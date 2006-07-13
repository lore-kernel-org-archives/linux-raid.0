From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Hardware assisted parity computation - is it now worth it?
Date: Thu, 13 Jul 2006 14:16:39 -0700
Message-ID: <e9c3a7c20607131416u11f68581j87d5a6c02b2a5018@mail.gmail.com>
References: <1152778739.26511.65.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1152778739.26511.65.camel@swtf.comptex.com.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Burn Alting <burn@goldweb.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/13/06, Burn Alting <burn@goldweb.com.au> wrote:
> Last year, there were discussions on this list about the possible
> use of a 'co-processor' (Intel's IOP333) to compute raid 5/6's
> parity data.
The MD patches have been posted for review, and the hardware offload
pieces are nearing completion.

> We are about to see low cost, multi core cpu chips with very
> high speed memory bandwidth. In light of this, is there any
> effective benefit to such devices as the IOP333?
It is true that upcoming server platforms have an abundance of CPU
cycles, but what about the case where an IOP is the host processor?
This is the primary target of the current work.  Also, what about the
more expensive RAID6 conditions (2-failed disks) where there might be
benefits to having MD split its work over many CPUs?

Regards,

Dan
