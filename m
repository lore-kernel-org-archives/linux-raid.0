From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: RE: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 11:34:54 -0600
Message-ID: <OMEKLMBKKEOEENCKLEIDGEFGCAAA.ryan@dynaconnections.com>
References: <OMEKLMBKKEOEENCKLEIDAEFGCAAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OMEKLMBKKEOEENCKLEIDAEFGCAAA.ryan@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>, Janusz Zamecki <janusz@pipi.ma.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"You will get 2 parallel sequential reads at around 120MB/sec
assuming you're not bus limited."

To clarify because this looks ambiguous to me now, you should be able to
perform 2 parallel sequential reads both at 60MB/sec = 120MB/sec total.

-ryan

