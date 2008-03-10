From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: LVM performance
Date: Mon, 10 Mar 2008 09:54:07 +0100
Message-ID: <47D4F72F.40203@student.tuwien.ac.at>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>	<20080218154203.6e2d1483@szpak>	<47BB30DF.1080006@student.tuwien.ac.at>	<18364.6868.854623.613958@tree.ty.sabi.co.UK>	<47BED119.4070000@student.tuwien.ac.at> <18384.63840.605334.155518@tree.ty.sabi.co.UK> <47D440D6.90509@student.tuwien.ac.at> <8D0FC34E-F0B0-4BAF-A466-2C8BC439E7FF@it-loops.com> <47D47264.4070404@student.tuwien.ac.at> <3AF45EEC-EC43-4AD4-ACD1-4EEDDE798346@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3AF45EEC-EC43-4AD4-ACD1-4EEDDE798346@it-loops.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Guntsche schrieb:
> That's exactly what I ment sorry for not being clear enough.
> If you have a chunk size of 128KB it makes sense to align the beginning 
> of the PV to this as well.

I was talking about stripe size, not chunk size. That 128KB stripe size 
is made up of n-1 chunks of an n-disk raid-5. In this case, 3 disks and 
64KB chunk size result in 128KB stripe size.

I assume if you tell the file system about this stripe size (or it 
figures it out itself, as xfs does), it tries to align its structures 
such that whole-stripe writes are more likely than partial writes. This 
means that md only has to write 3*64KB (2x data + parity).

If a write touches both (data_chunk_1 + offset) and (data_chunk_2 + 
offset), you can calculate (parity_chunk + offset) without reading 
anything. If it doesn't change all data chunks, you have to read either
* the current parity
* the data chunk(s) to be changed
* all other data chunks
to calculate parity.

So, if this 128KB write is offset by half a stripe, md has to read one 
of the chunks from each stripe prior to writing so it can update parity. 
Also, there are two parity chunks to write. So that's 2*64KB read + 
4*64KB write.

That's what I meant with stripe-aligning the PV (and thus the LV and 
thus the file system).

-- 
Oliver
