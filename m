From: "Montague, David" <David.Montague@stratus.com>
Subject: Management utility for Mylex fibre channel hardware raid
Date: Wed, 24 Mar 2004 11:08:39 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CAC3BCBB443DEC439198F230B4BCC7E90398FDF6@exna6-ftsaa.mis.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a Mylex hardware fibre channel raid controller attached to a qlogic
2300 fibre channel HBA.  Currently to reconfigure the array I have to remove
it from the Linux box and attach it to a windows box running Mylex global
array manager.  I have the Linux version of global array manager but the
client application does not appear to be communicating with the server.
Does the Linux version of gam support only scsi raid (DAC960 devices)?
Anyone have experience with this configuration?  Thanks in advance.
  --Dave Montague
