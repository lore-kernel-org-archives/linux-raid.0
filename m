From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Need help with my raid5
Date: Fri, 22 Mar 2013 20:13:00 +0800
Message-ID: <514C4ACC.9090605@fnarfbargle.com>
References: <loom.20130322T084406-543@post.gmane.org> <CAAMCDed0Pvs_+c6o5BvpVNi5ATZeu1abR1xeW=ikR8O9W5HJ1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDed0Pvs_+c6o5BvpVNi5ATZeu1abR1xeW=ikR8O9W5HJ1Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Mirko <mirko76@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/03/13 20:06, Roger Heflin wrote:

> I have self wired hot swap enclosures and my method is to read from
> the array and see which disk does not light up (confirm all others are
> active) and then cancel that read and go back and read from the bad
> disk to confirm which device that is, and if I want to be really save
> cancel that read make sure that disk stops then read again just to
> confirm I know what is what, no matter what you have, no matter how it
> is incorrectly labeled/wired this method should always work right.

Just as a data point. I have a spreadsheet with the serial number of 
each drive tied to the physical drive slot, so I know *exactly* which 
drive to pull when one dies. Use hdparm to give you a list of serial 
numbers to cut and paste into open-office, then just shuffle the cells 
around as you pull each drive to check it's number. Takes no time to 
create when you next have the machine down.

Your method is good too, and I've used that when in a hurry and not 
likely to cause damage if I get it wrong.
