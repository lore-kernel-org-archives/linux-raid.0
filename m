From: Brad Campbell <brad@wasp.net.au>
Subject: Re: raid5 code ok with 2TB + ?
Date: Sun, 28 Nov 2004 23:20:12 +0400
Message-ID: <41AA24EC.5020206@wasp.net.au>
References: <200411281819.iASIJmN00402@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411281819.iASIJmN00402@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Stephan van Hienen' <raid@a2000.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Your 2.2T array is not as big as you think!
> 
> 1TB = 2^40 not 1*10^12
> Maybe depending on if you are buying disk drives, or selling them! :)
> But when related to the 2TB limit it is 2^40.
> 
> 2206003968 blocks
> Divide by 1024 gives you 2154300.75 meg
> Divide by 1024 gives you 2103.8093 Gig
> Divide by 1024 gives you 2.0545 TB
> So you are just over 2TB. by 58520320 blocks or 55.8 Gig.
> 
> The only reason I am being exact is that you have not tested disk I/O beyond
> 2TB as much as you think.  Once, someone else made a similar 2T claim, after
> the math he was really below 2T.

Fair call. Having said that, if the code wrapped at 2TB then I would have blown away the 1st 55.8 
Gig of my partition, which would be enough to prove the code faulty :p)

-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
