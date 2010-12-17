From: "Patrick H." <linux-raid@feystorm.net>
Subject: integrity verification on raid-5?
Date: Fri, 17 Dec 2010 14:08:16 -0700
Message-ID: <4D0BD140.6040205@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there a way to do integrity verification on a raid-5 array? I'm 
working on building a storage system on SSDs under raid-5 and want to be 
able to perform periodic integrity checks. Basically just check the 
drives to make sure that they match what the parity drive has.
After a bit of googling I saw other people wanting the same thing but 
nobody with any result. I dont see why this cant be done, but is there 
any tool to do so?
