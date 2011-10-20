From: Yathindra <ydev@cs.utah.edu>
Subject: mdadm help
Date: Wed, 19 Oct 2011 20:49:27 -0600
Message-ID: <4E9F8C37.1060706@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to use the faulty personality of mdadm tool to inject various 
disk failure patterns
such as medium errors, unresponsive disk etc.

I'm wondering if there is an option to delay commands to get an 
unresponsive behavior.
Also, does rt (readtransient) and wt (writetransient) fault options act 
as medium errors.

Thanks,
Yathi
