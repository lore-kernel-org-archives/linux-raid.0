From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 09 Dec 2011 20:29:20 -0600
Message-ID: <4EE2C400.2000100@hardwarefreak.com>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <4EE263A5.3010107@hardwarefreak.com> <381720EC-8DCA-4862-9C62-22954CC7AA60@ucsc.edu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <381720EC-8DCA-4862-9C62-22954CC7AA60@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/9/2011 4:07 PM, Eli Morris wrote:

> So, that's not so great. As you mention in your last paragraph, the reason why we had Caviar Green drives to begin with is that our RAID vendor recommended them to us specifically for use in the RAID where they failed. I spoke with him after they failed and he insists that these drives were not the problem and that they are used without problem in similar RAIDs. He seems like a good guy, but ultimately, I have no way of knowing what to think of that. He thinks the four drives 'failed' because of a backplane issue, but, since the unit is older and out of warranty, and thus costly, that isn't really worth investigating.

Sure it is, if your data has value.  The style of backplanbe you have,
4x3 IIRC, is cheap.  If one board is flaky, replace it.  They normally
run only a couple hundred dollars, assuming your OEM still has some in
inventory.

If not, and you have $1500 squirreled away somewhere in the budget, grab
one of these and move the drives over:
http://www.newegg.com/Product/Product.aspx?Item=N82E16816133047

Sure, the Norco is definitely a low dollar 24 drive SAS/SATA JBOD unit.
 But the Areca expander module is built around the LSI SAS 2x36 ASIC,
the gold standard SAS expander chip on the market.

Do you have any dollars in your yearly budget for hardware
maintenance/replacement?

-- 
Stan
