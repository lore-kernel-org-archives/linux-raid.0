From: Terrance Hutchinson <Terrance.Hutchinson@dothill.com>
Subject: Idea: Dynamic growth of the md array
Date: Thu, 17 Nov 2011 11:53:59 -0700
Message-ID: <D32ED83685BD7643AC872D3EFF80E6BB0127480448@dc-ex1.power.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I know that mdadm supports growth of an array through the grow command but I would like to take it a step further. When a certain threshold is reach (user defined or default value) the user is emailed and the array is the grown to incorporate the next available disk or specified disk. This lets the user know what happened as well as prevent unnecessary downtime.

The idea is to make the growth automatic if the user wishes it do so, otherwise the existing behavior would be used.

Do you think this would be a good feature for mdadm? I've already begun working on it but wanted the community's opinion. If the overall consensus is that it's not a good idea, I'll post the diff on my website for those who would like it.


Thanks,
Terrance
