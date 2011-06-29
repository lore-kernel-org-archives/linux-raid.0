From: Tom De Mulder <tdm27@cam.ac.uk>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 11:33:23 +0100 (BST)
Message-ID: <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/06/11, David Brown wrote:

> However, AFAIUI, you are wrong about TRIM being essential for the
> continued high performance of SSDs.  As long as your SSDs have some
> over-provisioning (or you only partition something like 90% of the
> drive), and it's got good garbage collection, then TRIM will have
> minimal effect.

While you are mostly correct, over time even consumer SSDs will end up in 
this state.

Maybe I should have specified--my particular aim is to try and use (fairly 
high-end) consumer SSDs for "enterprise" server applications, hence the 
research into RAID. Most hardware RAID controllers that I know of don't 
pass on the TRIM command (for various reasons), so I was hoping to have 
more luck with software RAID.


Best,

--
Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
+44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
-> 29/06/2011 : The Moon is Waning Crescent (18% of Full)
