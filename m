From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 10:43:56 +0100
Message-ID: <ijdhtg$on7$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com> <20110215044434.GA9186@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215044434.GA9186@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/02/2011 05:44, Matt Garman wrote:
> On Mon, Feb 14, 2011 at 06:06:43PM -0800, Doug Dumitru wrote:
>
> I'll also add that this NAS needs to be optimized for *read*
> throughput.  As I mentioned, the only real write process is the
> daily "harvesting" of the data files.  Those are copied across
> long-haul leased lines, and the copy process isn't really
> performance sensitive.  In other words, in day-to-day use, those
> 40--50 client machines will do 100% reading from the NAS.
>

If you are not too bothered about write performance, I'd put a fair 
amount of the budget into ram rather than just disk performance.  When 
you've got the ram space to make sure small reads are mostly cached, the 
main bottleneck will be sequential reads - and big hard disks handle 
sequential reads as fast as expensive SSDs.

>
> No.  :)  72 SSDs sounds like fun; 550 spinning disks sound dreadful.
> I have a feeling I'd probably have to keep a significant number
> on-hand as spares, as I predict drive failures would probably be a
> weekly occurance.
>

Don't forget to include running costs in this - 72 SSDs use a lot less 
power than 550 hard disks.

