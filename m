From: Tom De Mulder <tdm27@cam.ac.uk>
Subject: Re: Software RAID and TRIM
Date: Tue, 19 Jul 2011 15:19:06 +0100 (BST)
Message-ID: <alpine.OSX.2.00.1107191516181.275@trogdor.csi.cam.ac.uk>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org> <j024fe$4va$1@dough.gmane.org> <j03ipg$uqk$1@dough.gmane.org>
 <j03m2p$jn1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j03m2p$jn1$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


In case people are interested, I ran more benchmarks. The impact of TRIM 
on an over-provisioned drive is remarkable: a 25% performance loss when 
using Postmark.

Because this isn't really on-topic for the MD mailing list, I've put it 
somewhere else:

http://tdm27.wordpress.com/2011/07/19/some-solid-state-drive-benchmarks/

My next goal, when I have the time, is to compare different amounts of 
over-provisioning.

--
Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
+44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
-> 19/07/2011 : The Moon is Waning Gibbous (75% of Full)
