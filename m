From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 5 performance issue.
Date: Sat, 06 Oct 2007 07:58:55 +1300
Message-ID: <4706896F.2060503@sauce.co.nz>
References: <20071003105321.06943824@zeus.pccl.info>	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>	<20071003211910.439ded54@alpha.digital-domain.net>	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>	<20071004150831.6edbf926@zeus.pccl.info>	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>	<Pine.LNX.4.64.0710041009530.8275@p34.internal.lan>	<20071004154441.31addcfe@zeus.pccl.info>	<Pine.LNX.4.64.0710041219240.25506@p34.internal.lan>	<20071004192653.25eb333b@alpha.digital-domain.net>	<Pine.LNX.4.64.0710050621350.8433@p34.internal.lan>	<20071005115719.4a71ab89@zeus.pccl.info>	<Pine.LNX.4.64.0710050707490.8433@p34.internal.lan>	<20071005135312.04856211@zeus.pccl.info>	<20071005143023.2bce96e9@zeus.pccl.info>	<Pine.LNX.4.64.0710051006370.21185@p34.internal.lan> <20071005171
 008.3e8a664d@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071005171008.3e8a664d@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you had a look at the smartctl -a outputs of all the drives?

Possibly one drive is being slow to respond due to seek errors etc. but 
I would perhaps expect to be seeing this in the log.

If you have a full backup and a spare drive, I would probably rotate it 
through the array.

Regards,

Richard
