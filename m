From: Richard Scobie <richard@sauce.co.nz>
Subject: LSI SAS1068E based controllers and md RAID
Date: Fri, 02 May 2008 09:20:41 +1200
Message-ID: <481A3429.2030708@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Any one had any experience using an LSI 1068E based SAS controller to 
build md RAID arrays using SATA drives on AIC Vitesse port expanders?

I am using an LSI SAS3442E card and the port expander ID is Vendor: AIC 
      Model: SJ16_ED-VB-1.0A2 Rev: 01A2.

I am seeing Code={Abort} errors on writes which are not due to faulty 
drives.

More details if anyone is interested, but at this stage would like to 
know of successful implementations.

Regards,

Richard
