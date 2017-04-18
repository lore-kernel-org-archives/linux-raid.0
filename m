From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: mdadm Consistency Policy initialization
Date: Tue, 18 Apr 2017 12:50:34 -0400
Message-ID: <9b041a85-7d61-75c8-7fbf-857e095ab838@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Artur,

In 5308f11727b889965efe5ac0e854d197c2b51f6d you introduced struct 
mdinfo: enum consistency_policy, but in mdadm.c you initialize it to 
UnSet which isn't part of the enum.

Is there any actual difference between CONSISTENCY_POLICY_UNKNOWN and 
UnSet? It seems suboptimal to mix and match within the enum like this, 
and if CONSISTENCY_POLICY_UNKNOWN does the job, couldn't we just 
initialize with that?

Cheers,
Jes
