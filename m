From: Graeme Gemmill <graeme@gemmill.name>
Subject: Controlled shut-down of mdadm
Date: Tue, 23 Mar 2010 16:35:12 +0000
Message-ID: <4BA8EDC0.4060506@gemmill.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On the (hopefully) rare occasions when my RAID server gets shut down, is 
it necessary or desirable to execute a mdadm --stop command in a 
shut-down script? Applications on other PCs may have files open, and if 
a prolonged mains break triggers a UPS shutdown, then there may be data 
loss (not that I'm running a reactor or a bank!).
Just a thought...
Regards to all
Graeme
