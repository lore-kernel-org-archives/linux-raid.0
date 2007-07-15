From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: FC7 install still lacks a feature
Date: Sun, 15 Jul 2007 08:28:20 -0400
Message-ID: <469A12E4.40008@tmr.com>
References: <4699609D.7020705@tmr.com>
Reply-To: For users of Fedora <fedora-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <fedora-list-bounces@redhat.com>
In-Reply-To: <4699609D.7020705@tmr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/fedora-list>,
	<mailto:fedora-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/fedora-list>
List-Post: <mailto:fedora-list@redhat.com>
List-Help: <mailto:fedora-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/fedora-list>,
	<mailto:fedora-list-request@redhat.com?subject=subscribe>
Sender: fedora-list-bounces@redhat.com
Errors-To: fedora-list-bounces@redhat.com
To: Linux RAID <linux-raid@vger.kernel.org>, For users of Fedora <fedora-list@redhat.com>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> When configuring RAID arrays, advanced users should be offered the 
> option to set the chunk size. And using ext3 or any other f/s which 
> knows a little about RAID, the stride= option check be set to the size 
> of a stripe, the number of data drives times the chunk size.
> 
> Booting a rescue or "Live-CD" and doing the partitioning will solve the 
> first, not the 2nd.
> 
I'm wrong, if I lay down a filesystem with the stride I want, and tell 
the installer not to reformat, I can get what I want. Woke up this 
morning with that thought.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

-- 
fedora-list mailing list
fedora-list@redhat.com
To unsubscribe: https://www.redhat.com/mailman/listinfo/fedora-list
