From: Alexander 'Leo' Bergolth <leo@strike.wu.ac.at>
Subject: Align lvm or dm-crypt to stripe or chunk size?
Date: Thu, 17 Jan 2013 10:35:48 +0100
Message-ID: <50F7C5F4.8080501@strike.wu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

If using some kind of container like lvm or dm-crypt that has a
data-offset inside my md device...
Do I need to align the data offset to the stripe size (chunk-size*number
of data-bearing disks) or just to the chunk size?

If aligning to the chunk size is sufficient, could anyone give an
explanation? Doesn't this break filesystem alignment inside the
container? (I.e. the --stripe-width option)

Thanks for your help,
--leo
-- 
e-mail   ::: Leo.Bergolth (at) wu.ac.at
fax      ::: +43-1-31336-906050
location ::: IT-Services | Vienna University of Economics | Austria

