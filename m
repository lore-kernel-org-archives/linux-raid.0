From: Neil Brown <neilb@suse.de>
Subject: RE: mdadm break / restore soft mirror
Date: Fri, 14 Dec 2007 11:04:30 +1100
Message-ID: <18273.51342.76883.231758@notabene.brown>
References: <05ED21952E28E94E8352836547A6BA37042318B4@achmsx001.hsa.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brett Maton on Thursday December 13
Sender: linux-raid-owner@vger.kernel.org
To: Brett Maton <Brett.Maton@simplyhealth.co.uk>
Cc: Jeff Breidenbach <jeff@jab.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 13, Brett.Maton@simplyhealth.co.uk wrote:

> How do I create the internal bitmap?  man mdadm didn't shed any
> light and my brief excursion into google wasn't much more helpful. 

  mdadm --grow --bitmap=internal /dev/mdX

> 
> The version I have installed is mdadm-1.12.0-5.i386 from RedHat
> which would appear to be way out of date! 

WAY!  mdadm 2.0 would be an absolute minimum, and linux 2.6.13 as an
absolute minimum, probably something closer to 2.6.20 would be a good
idea.

NeilBRown
