From: Sebastian =?ISO-8859-1?Q?Cla=DFen?=
	<Sebastian.Classen@freenet-ag.de>
Subject: raidtools vs. mdadm
Date: Wed, 08 Jun 2005 14:21:29 +0200
Message-ID: <1118233289.12044.13.camel@basti79.freenet-ag.de>
Reply-To: Sebastian.Classen@freenet-ag.de
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all...

We want to change from old raidtools to mdadm and have a problem:

While using the old raidtools the complete raid configuration was stored
in /etc/raidtab. With mdadm there are missing some informations in the
configuration file, espacialy those which are important for array
creation (e.g. the chunk size).

With raidtools it was possible to call 'mkraid /dev/md?' and all
informations have been fetched from raidtab. With mdadm you have to
manualy enter those missing configuration options when creating a new
array.

Is there any way to keep all configuration information together when
switching to mdadm?

Greets
  Sebastian.


