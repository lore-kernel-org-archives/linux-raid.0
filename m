From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: raid 0 on different size devices?
Date: 19 Nov 2003 14:00:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1069268427.6956.21.camel@opus>
References: <Pine.LNX.4.44.0311191154050.5855-100000@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311191154050.5855-100000@eglifamily.dnsalias.net>
To: Dan Egli <dan@eglifamily.dnsalias.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-11-19 at 13:57, Dan Egli wrote:
> Can the linux Software Raid handle devices of differing size? Basically my 
> issue is this: I've got two drives, a 27GB and a 40GB. I really want to 
> get them accessed as a single device. Is it possible to stack these drives 
> using like a raid 0?

yes - but having the both be the same speed would be a good thing.

-sv


