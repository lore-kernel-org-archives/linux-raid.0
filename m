From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Which (physical) disk is broken?
Date: Thu, 23 Dec 2004 10:00:59 +1100
Message-ID: <16841.64683.581049.327577@cse.unsw.edu.au>
References: <200412221639.iBMGdH911479@www.watkins-home.com>
	<874qie3qvy.fsf@pumba.bayour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Turbo Fredriksson on Wednesday December 22
Sender: linux-raid-owner@vger.kernel.org
To: Turbo Fredriksson <turbo@bayour.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 22, turbo@bayour.com wrote:
> >>>>> "Guy" == Guy  <bugzilla@watkins-home.com> writes:
> 
>     Guy> If you access your array, every disk in it will have disk activity.
> 
> He. That's one way I guess... I was more hoping for some support for
> this in mdadm...

Would be nice....
but until disks have little blue lights that can be turned on and off
under software control, and the linux block-device layer has an
interface to access this control, there isn't much mdadm can usefully
do.

NeilBrown
