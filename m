From: Abhijit Bhopatkar <abhopatk@cisco.com>
Subject: Potential race in dlm based messaging md-cluster.c
Date: Fri, 01 May 2015 00:06:44 +0530
Message-ID: <5542763C.90202@cisco.com>
References: <CAE3Hb8oss1JZ2u7g7OQQgrEtgQ1vbQou04isiS6eEqbS=uzbhw@mail.gmail.com> <CAE3Hb8qNczD30RrcHFYCR90Jf9QFD-XH=x89MAu4Dpmm80se0A@mail.gmail.com> <554251EA.3000807@suse.com> <CAE3Hb8pJ=0MB6EX5jVch28gj-gnf0Mp1wyzxBfWjzLf=SuV4sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE3Hb8pJ=0MB6EX5jVch28gj-gnf0Mp1wyzxBfWjzLf=SuV4sQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is a possibility of a receiver losing out on messages in certain 
corner conditions. One of the buggy case is if there is are two sender 
ready with messages to be sent. Sender 1 initially gets the TOKEN lock 
and proceeds.
After initial processing the sender of message 1 _will_ release TOKEN as 
soon as receiver releases ACK, it does not wait till ACK CR is 
re-acquired by receiver.

To illustrate the problem consider timeline for two senders and one 
receiver (we will ignore receive part for Sender2 node)

Sender1              Sender2                         Receiver
Get EX on TOKEN       Get EX on TOKEN
<Granted>                    <Wait till granted>

Get EX on MSG
write LVB
down MSG to CR
Get EX of ACK
<wait till granted>                                                     
      BAST for ACK
                                                             Get CR on MSG
                     read LVB
                     process
                     release ACK
AST for ACK
down ACK to CR
release MSG
release TOKEN
                    <granted>
                    Get EX on MSG
                    <... proceed ...>
                    release TOKEN
  <lost one message>
^^^^^^^^^^^^^^^^^
                                                              Get EX on MSG
                                                              Get CR on ACK
release MSG


Abhijit
